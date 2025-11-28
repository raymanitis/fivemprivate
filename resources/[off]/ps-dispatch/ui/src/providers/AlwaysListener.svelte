<script lang="ts">
	import { ReceiveNUI } from '@utils/ReceiveNUI'
	import { debugData } from '@utils/debugData'
	import { VISIBILITY, BROWSER_MODE, DISPATCH_MENU, DISPATCH_MENUS, DISPATCH, PLAYER, Locale, RESPOND_KEYBIND, MAX_CALL_LIST, shortCalls } from '@store/stores';

	debugData([
		{
			action: 'setVisible',
			data: true,
		},
	])

	debugData([
		{
			action: 'setBrowserMode',
			data: true
		},
	])

	debugData([
		{
			action: 'setupUI',
			data: {
				locales: {
					dispatch_detach: 'Detach from Dispatch Call',
					dispatch_attach: 'Attach to Dispatch Call',
					unit: 'Unit',
					units: 'Units',
					additionals: 'Additional Units',
				},
				player: {
					charinfo: {
						firstname: 'John',
						lastname: 'Doe'
					},
					metadata: {
						callsign: '1A-01'
					},
					citizenid: 'TEST123',
					job: {
						type: 'leo',
						name: 'police',
						label: 'Police'
					}
				},
				keybind: 'E',
				maxCallList: 25,
				shortCalls: false,
			}
		},
	])

	// Example dispatch calls for dev mode
	debugData([
		{
			action: 'newCall',
			data: {
				data: {
					id: 1,
					message: 'Discharge of a firearm',
					code: '10-13',
					codeName: 'shooting',
					icon: 'fas fa-gun',
					priority: 1,
					time: Date.now(),
					name: 'John Smith',
					number: '555-0123',
					information: 'Multiple shots fired in the area. Suspect last seen heading north.',
					street: 'Grove Street',
					gender: 'Male',
					automaticGunFire: false,
					weapon: 'Pistol',
					coords: { x: -50.0, y: -1750.0, z: 29.0 },
					jobs: ['leo']
				},
				timer: 5000
			}
		},
	], 1000)

	debugData([
		{
			action: 'newCall',
			data: {
				data: {
					id: 2,
					message: 'Reckless driving',
					code: '10-16',
					codeName: 'speeding',
					icon: 'fas fa-car',
					priority: 2,
					time: Date.now() - 30000,
					name: 'Jane Doe',
					number: '555-0456',
					information: 'Vehicle driving at high speeds, weaving through traffic.',
					street: 'Innocence Boulevard',
					gender: 'Female',
					vehicle: 'Adder',
					plate: 'ABC123',
					color: 'Red',
					class: 'Super car',
					doors: 'Two-door',
					heading: 'North Bound',
					coords: { x: 200.0, y: -800.0, z: 31.0 },
					jobs: ['leo']
				},
				timer: 5000
			}
		},
	], 2000)

	debugData([
		{
			action: 'newCall',
			data: {
				data: {
					id: 3,
					message: 'Person is injured',
					code: '10-52',
					codeName: 'persondown',
					icon: 'fas fa-user-injured',
					priority: 1,
					time: Date.now() - 60000,
					name: 'Unknown',
					number: '911',
					information: 'Person down, medical assistance required immediately.',
					street: 'Vinewood Boulevard',
					gender: 'Unknown',
					coords: { x: 300.0, y: 200.0, z: 45.0 },
					jobs: ['leo', 'ems']
				},
				timer: 5000
			}
		},
	], 3000)

	// Example dispatch menu data for dev mode
	debugData([
		{
			action: 'setDispatchs',
			data: [
				{
					id: 1,
					message: 'Discharge of a firearm',
					code: '10-13',
					icon: 'fas fa-gun',
					priority: 1,
					time: Date.now(),
					name: 'John Smith',
					number: '555-0123',
					information: 'Multiple shots fired in the area. Suspect last seen heading north.',
					street: 'Grove Street',
					gender: 'Male',
					automaticGunFire: false,
					weapon: 'Pistol',
					coords: [-50.0, -1750.0, 29.0],
					units: [],
					jobs: ['leo']
				},
				{
					id: 2,
					message: 'Reckless driving',
					code: '10-16',
					icon: 'fas fa-car',
					priority: 2,
					time: Date.now() - 30000,
					name: 'Jane Doe',
					number: '555-0456',
					information: 'Vehicle driving at high speeds, weaving through traffic.',
					street: 'Innocence Boulevard',
					gender: 'Female',
					vehicle: 'Adder',
					plate: 'ABC123',
					color: 'Red',
					class: 'Super car',
					doors: 'Two-door',
					heading: 'North Bound',
					coords: [200.0, -800.0, 31.0],
					units: [],
					jobs: ['leo']
				},
				{
					id: 3,
					message: 'Person is injured',
					code: '10-52',
					icon: 'fas fa-user-injured',
					priority: 1,
					time: Date.now() - 60000,
					name: 'Unknown',
					number: '911',
					information: 'Person down, medical assistance required immediately.',
					street: 'Vinewood Boulevard',
					gender: 'Unknown',
					coords: [300.0, 200.0, 45.0],
					units: [],
					jobs: ['leo', 'ems']
				},
				{
					id: 4,
					message: 'Store Robbery',
					code: '10-90',
					icon: 'fas fa-store',
					priority: 1,
					time: Date.now() - 120000,
					name: 'Store Clerk',
					number: '555-0789',
					information: 'Armed robbery in progress. Multiple suspects reported.',
					street: 'Little Seoul',
					gender: 'Male',
					coords: [-47.0, -1757.0, 29.0],
					units: [],
					jobs: ['leo']
				}
			]
		},
	], 4000)

	function browserHideAndShow(e: KeyboardEvent) {
		if (e.key === '=') {
			$VISIBILITY = true
		}
	}

	ReceiveNUI('setBrowserMode', (data: boolean) => {
		BROWSER_MODE.set(data)
		console.log('browser mode enabled')
		if (data) {
			window.addEventListener('keydown', browserHideAndShow)
		} else {
			window.removeEventListener('keydown', browserHideAndShow)
		}
	})

	ReceiveNUI('newCall', (data: any) => {
		DISPATCH.update(dispatches => {
			dispatches = dispatches || [];
			dispatches.push(data);
			return dispatches;
		});
	});

	ReceiveNUI('setDispatchs', (data: any) => {
		DISPATCH_MENU.set(data)
	});

	ReceiveNUI('setupUI', (data: any) => {
		PLAYER.set(data.player)
		Locale.set(data.locales)
		RESPOND_KEYBIND.set(data.keybind)
		MAX_CALL_LIST.set(data.maxCallList)
		shortCalls.set(data.shortCalls)
	});

</script>
