function registerClient(adId, adCanvasId) {
	$.ajax({
		type: "POST",
		url: "services/ads_request_handler/register_client",
		data: {adId: adId},
		success: function(data) {
			//alert(data);
		}
	});
}
