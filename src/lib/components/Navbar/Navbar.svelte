<script lang="ts">
	import { page } from '$app/state';

	function isCurrentPage(url: string) {
		return page.url.pathname === url;
	}
</script>

<nav>
	<ul class="nav">
		<li><a href="/" class:active={isCurrentPage('/')}>Sets</a></li>
		<li><a href="/song" class:active={isCurrentPage('/song')}>Songs</a></li>
		<li><a href="/setup" class:active={isCurrentPage('/setup')}>Setup</a></li>
	</ul>
</nav>

<style>
	nav {
		margin: 0;
		width: 100%;
	}

	.nav {
		display: flex;
		justify-content: center;
		margin: 0;
		padding: 1rem;
		padding-inline-start: 0;
		font-size: x-large;
	}

	.nav li {
		list-style-type: none;
	}

	.nav a {
		color: white;
		text-decoration: none;
		padding: 1rem;

		&.active {
			color: var(--purple);
		}
	}
</style>
