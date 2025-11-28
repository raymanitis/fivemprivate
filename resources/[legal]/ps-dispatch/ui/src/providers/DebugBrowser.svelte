<script>
    import { debugData } from '../utils/debugData';

	let show = false;
    //EXAMPLE

	
	let options = [
		{
			component: 'Show',
			actions : [
				{
					name: "show",
					action: "setVisible",
					data: true,
				},
				{
					name: "hide",
					action: "setVisible",
					data: false,
				},
			]
		},

		// {
		// 	component: 'Set Locales',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "updateLocale",
		// 			data: debugLocales,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Warrants',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setWarrantsData",
		// 			data: debugWarrants,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Bulletin',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setBulletinData",
		// 			data: debugBulletin,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Active Units',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setActiveUnits",
		// 			data: debugActiveUnits,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Camera',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setCameraData",
		// 			data: debugCamera,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Profile',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setProfileData",
		// 			data: debugProfiles,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Incidents',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setIncidentsData",
		// 			data: convertedIncidents,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Reports',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setReportsData",
		// 			data: debugReports,
		// 		},
		// 	]
		// },
		// {
		// 	component: 'Logs',
		// 	actions : [
		// 		{
		// 			name: "setData",
		// 			action: "setLogs",
		// 			data: debugLogs,
		// 		},
		// 	]
		// },
	]

</script>


<div class="absolute top-0 z-[1000]">
	<button class="bg-[#25262B] text-[#C1C2C5] p-2 font-medium"
		on:click={() => {
			show = !show;
		}}
	>
	Show
	</button>
	{#if show}
	<div class="w-fit h-fit bg-[#2C2E33] p-2">
		{#each options as option}
		<div class="flex flex-row gap-2 items-center">
			<p class="text-[#C1C2C5] mr-4">{option.component}</p>
			{#each option.actions as action}
			<button class="bg-[#20c997] text-white p-2"
				on:click={() => {

					if (action.custom == true) {
						action.customFunction();
						return
					}
					debugData([
						{
							action: action.action,
							data: action.data,
						},
					])
				}}
			>
			{action.name}
			</button>
			{/each}
		</div>
		{/each}
	</div>
	{/if}
</div>

