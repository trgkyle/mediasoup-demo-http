export function getProtooUrl({ roomId, peerId })
{
	const hostname = 'horus.techainer.com/mediasoup';

	return `wss://${hostname}/?roomId=${roomId}&peerId=${peerId}`;
}
