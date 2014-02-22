d3.text("content.txt", function(data) {
  ds = data.split("\n");
  ds = ds.slice(0,ds.length-1);
  tds = [];
  wd = [];

  // This is probably a horrible way of doing this.
  // But this part of the code isn't performance intensive.
  for ( i in ds ) {
    tds[ds[i]] = tds[ds[i]] ? tds[ds[i]]+1 : 1
  }

  for ( k in tds ) {
    wd.push({"text": k, "size": tds[k]});
  }
  //
  d3.layout.cloud().size([700,700])
    .words(wd)
    .padding(5)
    .timeInterval(1000)
    .font("Impact")
    .fontSize(function(d) {return d.size*15;})
    .rotate(0)
    .spiral("rectangular")
    .on("end", draw)
    .start();

  function draw(words) {
    d3.select("body").append("svg")
        .attr("width", 700)
        .attr("height", 700)
      .append("g")
        .attr("transform", "translate(450,450)")
      .selectAll("text")
        .data(words)
      .enter().append("text")
        .style("font-size", function(d) { return d.size + "px"; })
        .style("font-family", "Impact")
        .style("fill", "black")
        .attr("text-anchor", "middle")
        .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
        })
        .text(function(d) { return d.text; });
  }

});
