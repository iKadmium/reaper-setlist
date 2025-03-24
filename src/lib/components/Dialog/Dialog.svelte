<script lang="ts" module>
	export interface DialogProps {
		children?: Snippet;
	}
</script>

<script lang="ts">
	import type { Snippet } from 'svelte';

	let { children }: DialogProps = $props();
</script>

{@render children?.()}
