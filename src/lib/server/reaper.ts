import { getConfig } from './config';

export async function runCommand(command: string) {
	const { reaperUrl } = await getConfig();
	const url = new URL(`/_/${command}`, reaperUrl);
	const resp = await fetch(url);
	return await resp.text();
}

export async function goToEnd() {
	await runCommand('40043');
}

export async function goToStart() {
	await runCommand('40042');
}

export async function getTransport() {
	const transport = await runCommand('TRANSPORT');
	const secondsStr = transport.split('\t')[2];
	const seconds = parseInt(secondsStr, 10);
	return seconds;
}

export async function newTab() {
	await runCommand('40859');
}

export async function loadProject(name: string) {
	await runCommand(`OSC/loadproject:s${name}`);
}

export function getScript(folderPath: string) {
	const luaScript = `local is_new_value,filename,sectionID,cmdID,mode,resolution,val,contextstr = reaper.get_action_context()
		if contextstr == "" then
		  reaper.ShowConsoleMsg("No project"..val.."\\n")
		else
		  local project_name = string.gmatch(contextstr,"[^:]+:[^:]+:s=(.*)")()
		  local path = "${folderPath}" .. project_name .. "/" .. project_name .. ".rpp"
		  if project_name ~= nil then
			local x = "noprompt:" .. path
			reaper.Main_openProject(x)
		  end
		end`;
	return luaScript;
}
