// Will return whether the current environment is in a regular browser
// and not CEF
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const isEnvBrowser = (): boolean => !(window as any).invokeNative

// Basic no operation function
export const noop = () => {}

// Get the resource name for NUI paths
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const getResourceName = (): string => {
	return (window as any).GetParentResourceName ? (window as any).GetParentResourceName() : 'rm-perks';
}

// Get NUI image path
export const getNuiImagePath = (imagePath: string): string => {
	// If it's already an HTTP/HTTPS URL, return as-is
	if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
		return imagePath;
	}
	
	if (isEnvBrowser()) {
		// In browser, use relative path
		return imagePath;
	}
	
	// In FiveM, use nui:// protocol
	const cleanPath = imagePath.replace(/^\//, '');
	return `nui://${getResourceName()}/${cleanPath}`;
}