var counter=1;
function reloadStatistics() {
//	$.getJSON('services/rest/login', function(data) {});
	
	$.ajax({
		url: "services/statistics_request_handler/session_statistics",
		dataType: 'text',
//		data: data,
		success: function(data) {
			$("#sessionStatistics").html(data+", number of request: "+(counter++));
		}
	});
}
