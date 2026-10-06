"use client";
/* =====================================================================
   The 3D hero (React Three Fiber on three.js).

   An ILLUSTRATIVE little town at night: saffron hexagonal buildings are
   hostel messes, green houses are shelters, and glowing parcels fly
   along saffron-to-rose arcs from a mess to a shelter. When a parcel
   lands, a ring of light ripples out from the shelter. Sparks drift up
   from the table like steam off hot food.
   Nothing here is data: the positions and routes are fixed. The page
   says so right under the canvas. Live numbers come from MySQL below it.

   Performance (60 fps target on a student laptop):
   - about 80 small meshes + one point cloud, low-poly geometry, one
     64x64 generated glow texture, no shadows, no post-processing (the
     "bloom" is additive sprites, which cost almost nothing);
   - device pixel ratio capped at 1.75;
   - the parent stops the render loop when the canvas is off screen
     (frameloop="never"), so scrolling the rest of the page costs nothing.
   ===================================================================== */
import { Canvas, useFrame, useThree } from "@react-three/fiber";
import { useMemo, useRef } from "react";
import * as THREE from "three";

// Fixed layout on the ground plane (x, z). Messes on the left half, shelters on the right.
const MESSES = [[-3.4, -1.2], [-2.2, 1.8], [-0.6, -2.6], [-3.9, 1.0]];
const SHELTERS = [[2.6, -1.9], [3.4, 0.8], [1.2, 2.4], [0.9, -0.4], [3.8, -0.6]];
// Each route: [mess index, shelter index, seconds per trip, start offset 0..1]
const ROUTES = [[0, 0, 5.2, 0.0], [1, 2, 4.6, 0.35], [2, 3, 3.8, 0.6], [3, 1, 6.0, 0.2], [1, 4, 5.6, 0.75], [0, 3, 4.2, 0.5]];
const TRAIL = 7;            // glowing dots that follow each parcel
const SPARKS = 260;         // drifting particles

/* An arc from a to b that rises in the middle, like a flight path. */
function makeCurve([ax, az], [bx, bz]) {
  const a = new THREE.Vector3(ax, 0.75, az);
  const b = new THREE.Vector3(bx, 0.7, bz);
  const mid = a.clone().lerp(b, 0.5);
  mid.y = 1.6 + a.distanceTo(b) * 0.28;
  return new THREE.QuadraticBezierCurve3(a, mid, b);
}

/* A soft round glow drawn once on a small canvas; used by every sprite. */
function useGlowTexture() {
  return useMemo(() => {
    const c = document.createElement("canvas");
    c.width = c.height = 64;
    const g = c.getContext("2d");
    const grd = g.createRadialGradient(32, 32, 0, 32, 32, 32);
    grd.addColorStop(0, "rgba(255,255,255,1)");
    grd.addColorStop(0.25, "rgba(255,255,255,.55)");
    grd.addColorStop(1, "rgba(255,255,255,0)");
    g.fillStyle = grd; g.fillRect(0, 0, 64, 64);
    const t = new THREE.CanvasTexture(c);
    t.colorSpace = THREE.SRGBColorSpace;
    return t;
  }, []);
}

function Ground({ c }) {
  // A round table top, a faint street grid, and a glowing rim
  const grid = useMemo(() => {
    const pts = [];
    for (let i = -5; i <= 5; i++) {
      const s = Math.sqrt(Math.max(0, 30 - i * i)); // clip the grid lines to the disc
      pts.push(new THREE.Vector3(i, 0.003, -s), new THREE.Vector3(i, 0.003, s));
      pts.push(new THREE.Vector3(-s, 0.003, i), new THREE.Vector3(s, 0.003, i));
    }
    return new THREE.BufferGeometry().setFromPoints(pts);
  }, []);
  return (
    <group>
      <mesh rotation-x={-Math.PI / 2}>
        <circleGeometry args={[5.6, 72]} />
        <meshStandardMaterial color={c.surface} roughness={0.45} metalness={0.25} />
      </mesh>
      <lineSegments geometry={grid}>
        <lineBasicMaterial color={c.dark ? c.sky : c.line} transparent opacity={c.dark ? 0.12 : 0.8} />
      </lineSegments>
      <mesh rotation-x={-Math.PI / 2} position-y={0.004}>
        <ringGeometry args={[5.5, 5.62, 96]} />
        <meshBasicMaterial color={c.accent} transparent opacity={0.8} />
      </mesh>
    </group>
  );
}

/* A flat ring of light lying on the ground (under buildings, and the arrival ripple). */
function GlowRing({ color, r = 0.62, opacity = 0.6, blending }) {
  return (
    <mesh rotation-x={-Math.PI / 2} position-y={0.01}>
      <ringGeometry args={[r * 0.78, r, 40]} />
      <meshBasicMaterial color={color} transparent opacity={opacity} blending={blending} depthWrite={false} />
    </mesh>
  );
}

function Mess({ pos, c, glow }) {
  // A hexagonal block with a plate on top: the hostel mess
  return (
    <group position={[pos[0], 0, pos[1]]}>
      <mesh position-y={0.32}>
        <cylinderGeometry args={[0.42, 0.48, 0.64, 6]} />
        <meshStandardMaterial color={c.accent} emissive={c.accent} emissiveIntensity={c.dark ? 0.35 : 0.08} flatShading roughness={0.5} />
      </mesh>
      <mesh position-y={0.68}>
        <cylinderGeometry args={[0.34, 0.26, 0.06, 18]} />
        <meshStandardMaterial color={c.roof} roughness={0.3} metalness={0.2} />
      </mesh>
      <GlowRing color={c.accent} blending={c.blend} />
      <sprite position-y={0.9} scale={1.6}>
        <spriteMaterial map={glow} color={c.accent} transparent opacity={c.dark ? 0.35 : 0.18} blending={c.blend} depthWrite={false} />
      </sprite>
    </group>
  );
}

function Shelter({ pos, c, pulseRef }) {
  // A box with a pyramid roof: the shelter. pulseRef (0..1) is set to 1 by
  // a landing parcel; it makes the house bounce and a ring ripple outwards.
  const house = useRef();
  const ripple = useRef();
  useFrame((_, dt) => {
    pulseRef.current = Math.max(0, pulseRef.current - dt * 1.4); // decay
    const p = pulseRef.current;
    house.current.scale.setScalar(1 + 0.16 * Math.sin(p * Math.PI));
    ripple.current.scale.setScalar(1 + (1 - p) * 2.4);
    ripple.current.material.opacity = p * 0.9;
  });
  return (
    <group position={[pos[0], 0, pos[1]]}>
      <group ref={house}>
        <mesh position-y={0.26}>
          <boxGeometry args={[0.62, 0.52, 0.62]} />
          <meshStandardMaterial color={c.leaf} emissive={c.leaf} emissiveIntensity={c.dark ? 0.28 : 0.05} flatShading roughness={0.6} />
        </mesh>
        <mesh position-y={0.74} rotation-y={Math.PI / 4}>
          <coneGeometry args={[0.52, 0.44, 4]} />
          <meshStandardMaterial color={c.roof} flatShading roughness={0.7} />
        </mesh>
      </group>
      <GlowRing color={c.leaf} opacity={0.5} blending={c.blend} />
      <mesh ref={ripple} rotation-x={-Math.PI / 2} position-y={0.02}>
        <ringGeometry args={[0.5, 0.58, 48]} />
        <meshBasicMaterial color={c.leaf} transparent opacity={0} blending={c.blend} depthWrite={false} />
      </mesh>
    </group>
  );
}

function Route({ curve, c }) {
  // The path: a thin tube whose colour fades from saffron (mess) to rose (shelter)
  const geo = useMemo(() => {
    const tubular = 64, radial = 6;
    const g = new THREE.TubeGeometry(curve, tubular, 0.022, radial, false);
    const a = new THREE.Color(c.accent), b = new THREE.Color(c.accent2);
    const cols = [];
    for (let i = 0; i <= tubular; i++) {
      const col = a.clone().lerp(b, i / tubular);
      for (let j = 0; j <= radial; j++) cols.push(col.r, col.g, col.b);
    }
    g.setAttribute("color", new THREE.Float32BufferAttribute(cols, 3));
    return g;
  }, [curve, c.accent, c.accent2]);
  return (
    <mesh geometry={geo}>
      <meshBasicMaterial vertexColors transparent opacity={c.dark ? 0.55 : 0.7} blending={c.blend} depthWrite={false} />
    </mesh>
  );
}

function Parcel({ curve, seconds, offset, c, glow, onArrive }) {
  // A glowing box that travels the arc with a fading trail, then pauses at the shelter
  const box = useRef(), halo = useRef(), trail = useRef([]);
  const last = useRef(0);
  const tmp = useMemo(() => new THREE.Vector3(), []);
  useFrame(({ clock }) => {
    const cycle = seconds + 1.2;                        // 1.2 s pause at the shelter
    const t = ((clock.elapsedTime / cycle) + offset) % 1;
    const u = Math.min(1, (t * cycle) / seconds);       // 0..1 along the curve
    if (u >= 1 && last.current < 1) onArrive();          // just landed
    last.current = u;
    const moving = u < 1;
    curve.getPointAt(u, tmp);
    box.current.position.copy(tmp);
    box.current.rotation.y = clock.elapsedTime * 1.6;
    box.current.visible = halo.current.visible = moving;
    halo.current.position.copy(tmp);
    trail.current.forEach((m, k) => {
      const uu = u - (k + 1) * 0.018;
      m.visible = moving && uu > 0;
      if (m.visible) curve.getPointAt(uu, m.position);
    });
  });
  return (
    <group>
      <mesh ref={box}>
        <boxGeometry args={[0.2, 0.15, 0.2]} />
        <meshStandardMaterial color={c.accent} emissive={c.accent} emissiveIntensity={c.dark ? 1.4 : 0.5} flatShading />
      </mesh>
      <sprite ref={halo} scale={c.dark ? 0.9 : 0.6}>
        <spriteMaterial map={glow} color={c.accent} transparent opacity={c.dark ? 0.9 : 0.45} blending={c.blend} depthWrite={false} />
      </sprite>
      {Array.from({ length: TRAIL }, (_, k) => (
        <sprite key={k} ref={(el) => (trail.current[k] = el)} scale={0.34 - k * 0.035}>
          <spriteMaterial map={glow} color={c.accent2} transparent opacity={(c.dark ? 0.7 : 0.4) * (1 - k / TRAIL)} blending={c.blend} depthWrite={false} />
        </sprite>
      ))}
    </group>
  );
}

function Sparks({ c, glow }) {
  // Particles rising slowly from the table and wrapping around: "steam off hot food"
  const ref = useRef();
  const { positions, speeds } = useMemo(() => {
    const positions = new Float32Array(SPARKS * 3), speeds = new Float32Array(SPARKS);
    for (let i = 0; i < SPARKS; i++) {
      const r = Math.sqrt(Math.random()) * 5.4, a = Math.random() * Math.PI * 2;
      positions.set([Math.cos(a) * r, Math.random() * 4, Math.sin(a) * r], i * 3);
      speeds[i] = 0.08 + Math.random() * 0.22;
    }
    return { positions, speeds };
  }, []);
  useFrame((_, dt) => {
    const p = ref.current.geometry.attributes.position;
    for (let i = 0; i < SPARKS; i++) {
      let y = p.array[i * 3 + 1] + speeds[i] * dt;
      if (y > 4) y = 0;
      p.array[i * 3 + 1] = y;
    }
    p.needsUpdate = true;
  });
  return (
    <points ref={ref}>
      <bufferGeometry><bufferAttribute attach="attributes-position" args={[positions, 3]} /></bufferGeometry>
      <pointsMaterial map={glow} color={c.accent} size={0.09} sizeAttenuation transparent opacity={c.dark ? 0.75 : 0.35}
                      blending={c.blend} depthWrite={false} />
    </points>
  );
}

function Rig({ still }) {
  // Slow orbit plus a little parallax that follows the pointer
  const { camera, pointer } = useThree();
  const target = useMemo(() => new THREE.Vector3(), []);
  useFrame(({ clock }) => {
    const r = 12.6;   // far enough that the whole round "table" fits in frame
    if (still) {
      // reduced motion: jump straight to the pose (only one frame is drawn)
      camera.position.set(Math.sin(0.6) * r, 8.8, Math.cos(0.6) * r);
    } else {
      const t = clock.elapsedTime * 0.06;
      target.set(Math.sin(t + 0.6) * r + pointer.x * 0.8, 8.8 + pointer.y * 0.5, Math.cos(t + 0.6) * r);
      camera.position.lerp(target, 0.05);
    }
    camera.lookAt(0, 0.2, 0);
  });
  return null;
}

function Town({ c, still }) {
  const glow = useGlowTexture();
  const curves = useMemo(() => ROUTES.map(([m, s]) => makeCurve(MESSES[m], SHELTERS[s])), []);
  // one pulse value per shelter, written by parcels, read by shelters
  const pulses = useMemo(() => SHELTERS.map(() => ({ current: 0 })), []);
  return (
    <group>
      <Ground c={c} />
      {MESSES.map((p, i) => <Mess key={`m${i}`} pos={p} c={c} glow={glow} />)}
      {SHELTERS.map((p, i) => <Shelter key={`s${i}`} pos={p} c={c} pulseRef={pulses[i]} />)}
      {curves.map((cv, i) => <Route key={`r${i}`} curve={cv} c={c} />)}
      {!still && curves.map((cv, i) => (
        <Parcel key={`p${i}`} curve={cv} seconds={ROUTES[i][2]} offset={ROUTES[i][3]} c={c} glow={glow}
                onArrive={() => { pulses[ROUTES[i][1]].current = 1; }} />
      ))}
      {!still && <Sparks c={c} glow={glow} />}
      <Rig still={still} />
    </group>
  );
}

export default function HeroScene({ colors, running, still }) {
  // Dark theme: glowing (additive) light. Light theme: normal blending,
  // because adding light to a pale background only washes it out.
  const dark = new THREE.Color(colors.bg || colors.surface).getHSL({}).l < 0.5;
  const c = {
    ...colors,
    accent2: colors["accent-2"],
    dark,
    roof: dark ? colors.ink : colors.surface,
    blend: dark ? THREE.AdditiveBlending : THREE.NormalBlending,
  };
  return (
    <Canvas
      dpr={[1, 1.75]}
      camera={{ position: [7.6, 8.8, 11], fov: 36 }}
      // "demand" draws once (reduced motion); "never" pauses when off screen
      frameloop={!running ? "never" : still ? "demand" : "always"}
      gl={{ antialias: true, alpha: true, powerPreference: "high-performance" }}
      aria-hidden="true"
    >
      <fog attach="fog" args={[colors.bg, 14, 26]} />
      <ambientLight intensity={dark ? 0.35 : 0.9} />
      <hemisphereLight args={["#ffffff", c.line, dark ? 0.6 : 1.1]} />
      <directionalLight position={[4, 8, 3]} intensity={dark ? 1.1 : 1.6} />
      <pointLight position={[0, 2.5, 0]} intensity={dark ? 18 : 6} distance={9} color={c.accent} />
      <Town c={c} still={still} />
    </Canvas>
  );
}
