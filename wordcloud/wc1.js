d3.csv("../secondRound-resultsmod.csv", function(data) {
  //ds = data.split("\n");
  //ds = ds.slice(0,ds.length-1);
  //
  //  ds needs to be a list of words
  ds = [];
  for ( i in data ) {
    var sta = data[i]["Answers"];
    sta = sta.trim().split(" ");
    for ( j in sta ) {
      if (sta[j] != "") {
        ds.push(sta[j].trim().toLowerCase());
      }
    }


  }
  tds = [];
  wd = [];

  // This is probably a horrible way of doing this.
  // But this part of the code isn't performance intensive.
  for ( i in ds ) {
    tds[ds[i]] = tds[ds[i]] ? tds[ds[i]]+1 : 1
  }

  var maxVar = 0;
  for ( k in tds ) {
    wd.push({"text": k, "size": tds[k]});
    if ( tds[k] > maxVar ) {
      maxVar = tds[k];
    }
  }
  //
  // We want max font size to be 150. Just eyeing it up.
  var fs = d3.scale.linear().range([12,150]).domain([1,maxVar]);
  var colors = d3.scale.category20();

  var d1 = 1000;
  var d2 = 1000;

  d3.layout.cloud().size([d1,d2])
    .words(wd)
    .padding(5)
    .timeInterval(1)
    .font("Impact")
    .fontSize(function(d) {return fs(d.size);})
    .rotate(0)
    .spiral("rectangular")
    .on("end", draw)
    .start();
  function draw(words) {
    d3.select("body").append("svg")
      .attr("width", d1)
      .attr("height", d2)
      .append("g")
      .attr("transform", function(d){ return "translate("+d1/2+ ","+d2/2+")"} )
      .selectAll("text")
      .data(words)
      .enter().append("text")
      .style("font-size", function(d) { return d.size + "px"; })
      .style("font-family", "Exo")
      .style("fill", function(d,i){ return colors(d.text)})
      .attr("text-anchor", "middle")
      .attr("transform", function(d) {
        return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
      })
    .text(function(d) { return d.text; });
  }
});
