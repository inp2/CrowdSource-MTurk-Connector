#!/usr/bin/perl
use strict;
use warnings;
use Net::Amazon::MechanicalTurk;
use Net::Amazon::MechanicalTurk::RowData;

# Ben: 
# It now takes a url to an image as an argument.

# perl processhits.pl -register
# register your Amazon Mturk Keys
#
# perl processhits.pl 
# loadHITs for bulk loading many hits.
# Data is read from a CSV input file
# which is merged with the question template to produce the xml for the question.
# Each row corresponds to a HIT.
# Progress messages will be printed to the console.
# Successful HITId and HITTypeId's will be printed to a CSV success file.
# Failed rows from the input file will be printed to a CSV failure file.
#
#perl processhits.pl -get
#Allows the results of the HITs to be received in the loadhits-results.csv
#
#perl processhits.pl -remove
#This removes all success hits 
#
#perl processhits.pl -wordcloud
#This is where the code for the word cloud should be placed

if($ARGV[0] eq "-register")
{
 system("perl -MNet::Amazon::MechanicalTurk::Configurer -e configure");
 die("You have been registered!");
}
elsif($ARGV[0] eq "-get")
{
	&getResults;
	die("Your files are located in loadhits-results.csv");
}
elsif($ARGV[0] eq "-remove")
{
	&removeHITS;
	die;
}
elsif($ARGV[0] eq "-wordcloud")
{
	&createWordCloud;
	die;
}
elsif($ARGV[0] eq "-roundOne")
{
  &roundOne;
  die;
}
elsif($ARGV[0] eq "-getOne")
{
	&getFirstResults;
	die("Your files are located in loadhits-results.csv");
}
elsif($ARGV[0] eq "-roundTwo")
{
  &roundTwo;
  die;
}
elsif($ARGV[0] eq "-getTwo")
{
	&getSecondResults;
	die("Your files are located in loadhits-results.csv");
}

my $question1 = "Please provide three adjectives to describe the picture.";
sub question1Template {
    my %params = %{$_[0]};
    return <<END_XML;
<?xml version="1.0" encoding="UTF-8"?>
<QuestionForm xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2005-10-01/QuestionForm.xsd">
  <Question>
    <QuestionIdentifier>1</QuestionIdentifier>
    <QuestionContent>
      <FormattedContent><![CDATA[<h1>Describe image using three adjectives</h1>
<p><img alt="" src="$ARGV[1]" /></p>
<p>Enter words, <b>seperated by spaces</b> into box:</p>]]></FormattedContent>
    </QuestionContent>
    <AnswerSpecification>
      <FreeTextAnswer/>
    </AnswerSpecification>
  </Question>
</QuestionForm>
END_XML
}

sub roundOne
{
  my $properties = {
      Title       => 'Describe Image',
      Description => 'Describe an image using three adjectives',
      Keywords    => 'description, tagging, adjective',
      Reward => {
          CurrencyCode => 'USD',
          Amount       => 0.00
      },
      RequesterAnnotation         => 'Question',
      AssignmentDurationInSeconds => 60,
      AutoApprovalDelayInSeconds  => 60 * 60 * 10,
      MaxAssignments              => 10,
      LifetimeInSeconds           => 60 * 60
  };

  my $mturk = Net::Amazon::MechanicalTurk->new();

  $mturk->loadHITs(
      properties => $properties,
      input      => "firstRound-input.csv",
      progress   => \*STDOUT,
      question   => \&question1Template,
      success    => "firstRound-success.csv",
      fail       => "loadhits-failure.csv"
  );

}

sub question2Template {
    my %params = %{$_[0]};
    return <<END_XML;
<?xml version="1.0" encoding="UTF-8"?>
<QuestionForm xmlns="http://mechanicalturk.amazonaws.com/AWSMechanicalTurkDataSchemas/2005-10-01/QuestionForm.xsd">
  <Question>
    <QuestionIdentifier>2</QuestionIdentifier>
    <QuestionContent>
      <FormattedContent><![CDATA[<h1>Remove any profanities, swears, or vulgar language.</h1>
<p>Edit words so that they are, <b>seperated by spaces</b>, contain only adjectives, and contain no profanity:</p>]]></FormattedContent>
    </QuestionContent>
    <AnswerSpecification>
      <FreeTextAnswer>
      <DefaultText> $params{Answer1} </DefaultText>
      </FreeTextAnswer>
    </AnswerSpecification>
  </Question>
</QuestionForm>
END_XML
}
sub roundTwo
{
  my $properties = {
      Title       => 'Filter some Provided text',
      Description => 'Remove words that are profanity or not adjectives.',
      Keywords    => 'description, filter, adjective',
      Reward => {
          CurrencyCode => 'USD',
          Amount       => 0.00
      },
      RequesterAnnotation         => 'Question',
      AssignmentDurationInSeconds => 60,
      AutoApprovalDelayInSeconds  => 60 * 60 * 10,
      MaxAssignments              => 1,
      LifetimeInSeconds           => 60 * 60
  };

  my $mturk = Net::Amazon::MechanicalTurk->new();

  $mturk->loadHITs(
      properties => $properties,
      input      => "firstRound-results.csv",
      progress   => \*STDOUT,
      question   => \&question2Template,
      success    => "secondRound-success.csv",
      fail       => "loadhits-failure.csv"
  );

}



sub getFirstResults
{
	my $mturk = Net::Amazon::MechanicalTurk->new;

	$mturk->retrieveResults(
		input => "firstRound-success.csv",
		output => "firstRound-results.csv",
		progress => \*STDOUT
	);
}
sub getSecondResults
{
	my $mturk = Net::Amazon::MechanicalTurk->new;

	$mturk->retrieveResults(
		input => "secondRound-success.csv",
		output => "secondRound-results.csv",
		progress => \*STDOUT
	);
}


# This wont work at all.
sub removeHITS
{
	my $mturk = Net::Amazon::MechanicalTurk->new;
	my $data = Net::Amazon::MechanicalTurk::RowData->toRowData("loadhits-success.csv");

	my $autoApprove = 1;
	
	$data->each(sub {
		my ($data, $row) = @_;
		my $hitId = $row->{HITId};
	
		printf "Deleting hit $hitId\n";
		eval {
			$mturk->deleteHIT($hitId, $autoApprove);
		};
		if($@) {
			warn "Couldn't delete hit $hitId - " . $mturk->response->errorCode . "\n";
		}
	}); 
}

sub createWordCloud
{
  print "Printing the word cloud";
  open(my $fh, '>', 'out.html');
  print $fh  <<HTML;
<!DOCTYPE html>
<html>
<head>
<style>
div {
    white-space: nowrap;
    vertical-align:top;
}
img{
    vertical-align:top;
}
</style>
<title>Word Cloud Example</title>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<link href='http://fonts.googleapis.com/css?family=Exo' rel='stylesheet' type='text/css'>
<!-- D3 Word cloud library from: "https://github.com/jasondavies/d3-cloud" -->
<script src="https://raw2.github.com/jasondavies/d3-cloud/master/d3.layout.cloud.js" charset="utf-8"></script>
</head>
<body>
<center>
<img src="$ARGV[1]" alt="" width="500">
</center>
<script>
d3.text("content.txt", function(data) {
  ds = data.split("\\n");
  ds = ds.slice(0,ds.length-1);
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
  var fs = d3.scale.linear().range([1,150]).domain([1,maxVar]);
  var colors = d3.scale.category20();

  // We should set these programmatically. I'm just not sure how.
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
    d3.select("center").append("svg")
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
</script>
</body>
</html>
HTML
  close $fh;
  die;
}

