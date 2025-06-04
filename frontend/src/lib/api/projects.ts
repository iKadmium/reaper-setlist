// Project management API functions

export interface ProjectListResponse {
    success: boolean;
    projects: string[];
    message?: string;
}

export interface ProjectSetRootResponse {
    success: boolean;
    message: string;
}

export interface ProjectLoadResponse {
    success: boolean;
    message: string;
}

export interface ProjectLoadRequest {
    relative_path: string;
}

export async function setProjectRoot(): Promise<ProjectSetRootResponse> {
    const response = await fetch('/api/projects/set-root', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    });

    if (!response.ok) {
        throw new Error(`Failed to set project root: ${response.statusText}`);
    }

    return response.json();
}

export async function listProjects(): Promise<ProjectListResponse> {
    const response = await fetch('/api/projects/list', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    });

    if (!response.ok) {
        throw new Error(`Failed to list projects: ${response.statusText}`);
    }

    return response.json();
}

export async function loadProject(relativePath: string): Promise<ProjectLoadResponse> {
    const response = await fetch('/api/projects/load', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ relative_path: relativePath })
    });

    if (!response.ok) {
        throw new Error(`Failed to load project: ${response.statusText}`);
    }

    return response.json();
}
