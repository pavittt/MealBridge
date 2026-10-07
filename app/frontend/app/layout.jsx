/* Root layout: fonts, theme bootstrap, and the app shell around every page. */
import { Fraunces, Geist, Geist_Mono } from "next/font/google";
import Shell from "@/components/Shell";
import "leaflet/dist/leaflet.css";
import "./globals.css";

// Editorial serif for titles (variable: optical size, softness, the "wonky" italic),
// Geist for everything you read and click, Geist Mono for SQL and numbers.
const display = Fraunces({ subsets: ["latin"], variable: "--font-display-family", weight: "variable",
                           style: ["normal", "italic"], axes: ["opsz", "SOFT", "WONK"] });
const body = Geist({ subsets: ["latin"], variable: "--font-body-family" });
const mono = Geist_Mono({ subsets: ["latin"], variable: "--font-mono-family" });

export const metadata = {
  title: "MealBridge",
  description: "Surplus hostel mess food, matched to nearby shelters before it expires. A database systems project.",
};

// Runs before the page paints, so a saved dark choice never flashes light.
const themeScript = `try{if(localStorage.getItem('mb_theme')==='dark')document.documentElement.setAttribute('data-theme','dark')}catch(e){}`;

export default function RootLayout({ children }) {
  return (
    <html lang="en" data-scroll-behavior="smooth" className={`${display.variable} ${body.variable} ${mono.variable}`} suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeScript }} />
      </head>
      <body className="min-h-screen">
        {/* the slow colour pools behind every page (globals.css .aurora) */}
        <div className="aurora" aria-hidden="true"><i /><i /><i /></div>
        <Shell>{children}</Shell>
      </body>
    </html>
  );
}
