{crmTitle string="<span class='data_count'><span class='filter-count'></span> Grants out of <span class='total-count'></span></span>"}

<div class="row" >
<div id="type" class="col-md-2"><h3>Type</h3><div class="graph"></div></div>
<div id="status" class="col-md-2"><h3>Status</h3><div class="graph"></div></div>
<div id="date" class="col-md-4"><h3>Date created</h3><div class="graph"></div></div>
</div>

<div class="row">
<table class="table table-striped" id="table">

<thead><tr>
<th>Date</th>
<th>Code</th>
<th>Grantee or Host</th>
<th>Type</th>
<th>Status</th>
</tr></thead>
</table>
</div>

<div class="row">
</div>

<script>
{literal}
(function() { function bootViz() {
// Use our versions of the libraries.
var d3 = CRM.civisualize.d3, dc = CRM.civisualize.dc, crossfilter = CRM.civisualize.crossfilter;

{/literal}
var data = {crmSQL file="cases"};
var apitypes ={crmAPI entity="case" action="getoptions" field="case_type_id"}.values;
var apistatus ={crmAPI entity="case" action="getoptions" field="status_id"}.values;
{literal}
var types={};
var statuses={};
Object.entries(apitypes).forEach(function(d){types[d[1].key]=d[1].value});
Object.entries(apistatus).forEach(function(d){statuses[d[1].key]=d[1].value});

var dateFormat = d3.timeParse("%Y-%m-%d %H:%M:%S");
var currentDate = new Date();

var prettyDate = function (dateString){
  var date = new Date(dateString);
  var d = date.getDate();
  var m = ('0' + (date.getMonth()+1)).slice(-2);
  var y = date.getFullYear();
  var min = ('0' + date.getMinutes()).slice(-2);
  return d+'/'+m+'/'+y +' ' +date.getHours() + ':'+min;
}


function lookupTable(data,key,value) {
  var t= {}
  data.forEach(function(d){t[d[key]]=d[value]});
  return t;
}

data.values.forEach(function(d){
  d.date = dateFormat(d.date);
});



var ndx  = crossfilter(data.values)
  , all = ndx.groupAll();

var totalCount = dc.dataCount("h1 .data_count")
      .dimension(ndx)
      .group(all);

function drawDate (dom) {
  var dim = ndx.dimension(function(d){return d3.timeDay(d.date)});
  var group = dim.group().reduceSum(function(d){return 1;});
//  var group = dim.group().reduceSum(function(d){return d.recipients;});
  var graph=dc.lineChart(dom)
   .margins({top: 10, right: 10, bottom: 20, left:50})
    .height(100)
    .dimension(dim)
    .renderArea(true)
    .group(group)
    .brushOn(true)
    .x(d3.scaleTime().domain(d3.extent(dim.top(2000), function(d) { return d.date; })))
    .round(d3.timeDay.round)
    .elasticY(true)
    .xUnits(d3.timeDays);

   graph.yAxis().ticks(3);
   graph.xAxis().ticks(5);
  return graph;
}


function drawPercent (dom,attr,name) {
  //var dim = ndx.dimension(function(d){return 10 * Math.floor((accessor(d)/d.recipients* 10)) });
  var dim = ndx.dimension(function(d){return attr(d) });
  var group = dim.group().reduceSum(function(d){return 1;});
  //var group = dim.group().reduceSum(function(d){return d.recipients;});


  var graph = dc.pieChart(dom+ " .graph")
    .height(100)
    .width(150)
    .label(function(d){return name(d.key)})
    .dimension(dim)
    .group(group)


   return graph;
}


function drawTable(dom) {
  var dim = ndx.dimension (function(d) {return d.id});
  var graph = dc.dataTable(dom)
    .dimension(dim)
    .size(2000)
    .group(function(d){ return ""; })
    .sortBy(function(d){ return d.date; })
    .order(d3.descending)
    .columns(
	[
	    function (d) {
		return prettyDate(d.date);
	    },
	    function (d) {
             return "<a href='/civicrm/case/a/?case_type_category=Cases#/case/list?caseId="+d.id+"'>"+d.code+"</a>";
	    },
	    function (d) {
              return d.display_name
	    },
	    function (d) {
              return types[d.type] 
	    },
	    function (d) {
              return statuses[d.status]
	    },
	]
    );

  return graph;
}

 
drawPercent("#type", function(d){return d.type}, function(d){return types[d]});
drawPercent("#status", function(d){return d.status},function(d){return statuses[d]});
drawTable("#table");
//drawType("#type .graph");
drawDate("#date .graph");
//drawStatus("#status .graph");
//drawSender("#sender .graph");
//drawCampaign("#campaign .graph");

dc.renderAll();
  }

  // Boot our script as soon as ready.
  CRM.civisualizeQueue = CRM.civisualizeQueue || [];
  CRM.civisualizeQueue.push(bootViz);

})();
</script>

<style>
.row {
  display: flex;
  flex-wrap: wrap;
  margin: 0 -1rem;
}
.row > div {
  padding: 1rem;
  flex: 1 0 auto;
}
</style>
{/literal}
