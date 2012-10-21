var counter=1;
function reloadStatistics() {
//	$.getJSON('services/rest/login', function(data) {});
	
	$.ajax({
		url: "services/rest/login",
		dataType: 'text',
//		data: data,
		success: function(data) {
			$("#sessionStatistics").html(data+(counter++));
		}
	});
}
