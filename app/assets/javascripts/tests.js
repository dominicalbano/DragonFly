// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
	select_cms = document.getElementById('test_app_type_cms');
	select_clw = document.getElementById('test_app_type_clw');
	if(select_cms.checked || select_clw.checked){
	    var test_selector = document.getElementById('test-selector');
	    test_selector.style.display = "block";
	    var submitter = document.getElementById('submiter');
	    submiter.style.display = "block";
	}
	// set the drop downs too
	var cms_tests = document.getElementById('cms-tests');
	var clw_tests = document.getElementById('clw-tests');
	if(select_cms.checked){
	  	cms_tests.style.display = "block";
	  	clw_tests.style.display = "none";
	}
	if(select_clw.checked){
	  	cms_tests.style.display = "none";
	  	clw_tests.style.display = "block";
	}
  	
});

function check_value(){
	select_cms = document.getElementById('test_app_type_cms');
	select_clw = document.getElementById('test_app_type_clw');
	if(select_cms.checked || select_clw.checked){
	    var test_selector = document.getElementById('test-selector');
	    test_selector.style.display = "block";
	    var submitter = document.getElementById('submiter');
	    submiter.style.display = "block";
  	}
  	var cms_tests = document.getElementById('cms-tests');
	var clw_tests = document.getElementById('clw-tests');
  	if(select_cms.checked){
  		cms_tests.style.display = "block";
  		clw_tests.style.display = "none";
  	}
  	if(select_clw.checked){
  		cms_tests.style.display = "none";
  		clw_tests.style.display = "block";
  	}

}

function show_load(){
	// ajax loader
}

// {
//    "errors":[
//       {
//         "id":1,
//         "page":"http://url.com",
//         "page_errors":[
//         	{
//         		"message":"error["errorMessage"]",
//         		"file":"error["sourceName"]",
//         		"line":"error["lineNumber"]"
//         	},
//         	{
//         		"message":"error["errorMessage"]",
//         		"file":"error["sourceName"]",
//         		"line":"error["lineNumber"]"
//         	}
//         ]
//       },
//       {
//         "id":2,
//         "page":"http://url2.com",
//         "page_errors":[
//         	{
//         		"message":"error["errorMessage"]",
//         		"file":"error["sourceName"]",
//         		"line":"error["lineNumber"]"
//         	}
//         ]
//       }
//     ]
// }
 