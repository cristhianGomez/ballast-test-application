import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function Home() {
  return (
    <div className="container mx-auto py-10">
      <div className="flex flex-col items-center justify-center space-y-8">
        <div className="text-center">
          <h1 className="text-4xl font-bold tracking-tight">Welcome to Ballast Lane</h1>
          <p className="mt-4 text-lg text-muted-foreground">
            A full-stack application built with Next.js 15 and Rails 7
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card>
            <CardHeader>
              <CardTitle>Pokemon API</CardTitle>
              <CardDescription>
                Browse Pokemon data fetched from the PokeAPI through our Rails backend
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Button asChild>
                <a href="/pokemon">View Pokemon</a>
              </Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Authentication</CardTitle>
              <CardDescription>
                Secure authentication with Devise and JWT tokens
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="flex gap-2">
                <Button variant="outline" asChild>
                  <a href="/login">Login</a>
                </Button>
                <Button asChild>
                  <a href="/register">Register</a>
                </Button>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>API Health</CardTitle>
              <CardDescription>Check the status of the backend API service</CardDescription>
            </CardHeader>
            <CardContent>
              <Button variant="secondary" asChild>
                <a href="/api/v1/health" target="_blank" rel="noopener noreferrer">
                  Check Health
                </a>
              </Button>
            </CardContent>
          </Card>
        </div>

        <div className="mt-8 rounded-lg bg-muted p-6">
          <h2 className="text-lg font-semibold">Tech Stack</h2>
          <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div>
              <h3 className="font-medium">Frontend</h3>
              <ul className="mt-2 text-sm text-muted-foreground">
                <li>Next.js 15</li>
                <li>TypeScript</li>
                <li>Tailwind CSS</li>
                <li>shadcn/ui</li>
              </ul>
            </div>
            <div>
              <h3 className="font-medium">Backend</h3>
              <ul className="mt-2 text-sm text-muted-foreground">
                <li>Rails 7 API</li>
                <li>PostgreSQL</li>
                <li>Devise + JWT</li>
                <li>RSpec</li>
              </ul>
            </div>
            <div>
              <h3 className="font-medium">Infrastructure</h3>
              <ul className="mt-2 text-sm text-muted-foreground">
                <li>Docker</li>
                <li>Docker Compose</li>
                <li>Hot Reload</li>
                <li>Volume Mounts</li>
              </ul>
            </div>
            <div>
              <h3 className="font-medium">Patterns</h3>
              <ul className="mt-2 text-sm text-muted-foreground">
                <li>Service Objects</li>
                <li>API Versioning</li>
                <li>Server Components</li>
                <li>Zod Validation</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
