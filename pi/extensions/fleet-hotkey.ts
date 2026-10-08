import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	pi.registerShortcut("ctrl+shift+a", {
		description: "Open the pi-subagents fleet inspector",
		handler: () => {
			pi.sendUserMessage("/subagents-fleet", { expandPromptTemplates: true });
		},
	});
}
