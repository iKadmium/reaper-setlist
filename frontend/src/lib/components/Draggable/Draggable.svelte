<script lang="ts" module>
	export interface DraggableProps {
		onmove: (y: number) => void;
		onstart: () => void;
		onend: (y: number) => void;
	}
</script>

<script lang="ts">
	import { browser } from '$app/environment';
	import { onDestroy, onMount } from 'svelte';
	import DragIcon from 'virtual:icons/mdi/drag';

	let { onmove, onstart, onend }: DraggableProps = $props();
	let lastY = $state(0);
	let mouseIsDown = $state(false);

	onMount(() => {
		if (browser) {
			window.addEventListener('mousemove', handleMouseMove);
			window.addEventListener('mouseup', handleMouseUp);
		}
	});

	onDestroy(() => {
		if (browser) {
			window.removeEventListener('mousemove', handleMouseMove);
			window.removeEventListener('mouseup', handleMouseUp);
		}
	});

	function handleTouchMove(event: TouchEvent) {
		event.preventDefault();
		lastY = event.touches[0].clientY;
		onmove(lastY);
	}

	function handleTouchStart(event: TouchEvent) {
		event.preventDefault();
		onstart();
	}

	function handleTouchEnd(event: TouchEvent) {
		event.preventDefault();
		onend(lastY);
	}

	function handleMouseMove(event: MouseEvent) {
		if (!mouseIsDown) return;
		event.preventDefault();
		lastY = event.clientY;
		onmove(lastY);
	}

	function handleMouseDown(event: MouseEvent) {
		event.preventDefault();
		mouseIsDown = true;
		onstart();
	}

	function handleMouseUp(event: MouseEvent) {
		event.preventDefault();
		mouseIsDown = false;
		onend(lastY);
	}

	function handleSelectStart(event: Event) {
		event.preventDefault();
		event.stopPropagation();
	}
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
	class="drag-container"
	ontouchstart={handleTouchStart}
	ontouchmove={handleTouchMove}
	ontouchend={handleTouchEnd}
	onmousemove={handleMouseMove}
	onmousedown={handleMouseDown}
	onselectstart={handleSelectStart}
>
	<DragIcon />
</div>

<style>
	.drag-container {
		display: flex;
		align-items: center;
		font-size: 24px;
		cursor: move;
		touch-action: none;
	}
</style>
