export function getProtooUrl({ roomId, peerId })
{
	const hostname = '192.168.40.4:30706/mediasoup';

	return `ws://${hostname}/?roomId=${roomId}&peerId=${peerId}`;
}
