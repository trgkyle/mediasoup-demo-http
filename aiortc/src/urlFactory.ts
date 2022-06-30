let protooPort = 4443;

const hostname = process.env.HOSTNAME || 'test.mediasoup.org';

if (hostname === 'test.mediasoup.org')
	protooPort = 4443;

export function getProtooUrl(
	{ roomId, peerId }:
	{ roomId: string; peerId: string; }
): string
{
	return `ws://${hostname}:${protooPort}/?roomId=${roomId}&peerId=${peerId}`;
}
