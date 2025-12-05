const path = GetResourcePath(GetCurrentResourceName());
const Jimp = require('jimp');

let originalTexture = null;

async function beginSpritesReplacement() {
	try {
		originalTexture = await Jimp.read(`${path}/utils/miscellaneous/imgs/blips_texturesheet_ng.png`);
		return true;
	} catch (error) {
		return false;
	}
}
exports('beginSpritesReplacement', beginSpritesReplacement);

async function replaceSprite(imageName, x, y) {
	try {
		let newSprite = await Jimp.read(`${path}/_sprites/REPLACEABLE/${imageName}`);
		newSprite = newSprite.resize(64, 64, Jimp.RESIZE_NEAREST_NEIGHBOR);
		
		const spriteWidth = newSprite.getWidth();
		const spriteHeight = newSprite.getHeight();

		const mask = new Jimp(spriteWidth, spriteHeight, 0x00000000);

		originalTexture.mask(mask, x, y);

		originalTexture.blit(newSprite, x, y, 0, 0, spriteWidth, spriteHeight);

		return true;
	} catch (error) {
		return false;
	}
}
exports('replaceSprite', replaceSprite);

async function endSpritesReplacement() {
	try {
		await originalTexture.writeAsync(`${path}/utils/miscellaneous/imgs/blips_texturesheet_ng_custom.png`);
		return true;
	} catch (error) {
		return false;
	}
}
exports('endSpritesReplacement', endSpritesReplacement);