# Compass Writeup
## Homework 4: A Crowd-Powered Application 
> Due Feb. 25 @ 2:30pm

This is a GROUP assignment that is to be performed by your assigned project
group. For the assignment, your group will utilize crowd workers to produce a
word cloud representing first impressions of a visual design. Your group will
need to install, configure, and apply an environment for programmatically
creating HITs and receiving responses of the task outcomes using the Mechanical
Turk API. The outcomes can then be used as input to an available toolkit or
known algorithm for producing the word cloud. The report should be submitted as
a PDF attachment to this assignment.

### Setup
To access the Amazon.com Mechanical Turk API, you must have a requester
account, which you have, and an Amazon Web Services (AWS) account, which you
must create. To create the AWS account, navigate to the Amazon.com Mechanical
Turk Developer portal and select "Create AWS Account" in the Getting Started
area of the page, and follow the instructions. Once complete, you will receive
a set of access keys that must be supplied when accessing the API. The next
step is to install a language-specific SDK. Do not install the command line
tools because you cannot embed the commands into a broader program. Talk as a
group and select the language-specific SDK that best matches the skills of the
group. We do not care which one you use and, as far as we can tell, the SDKs
offer the same or similar programming abstractions. Install the SDK and work
through the [Getting
Started](http://docs.aws.amazon.com/AWSMechTurk/latest/AWSMechanicalTurkGettingStartedGuide/SetUp.html)
documentation along with inspecting the code examples and documentation that
come with the SDK. Mechanical Turk is structured as a series of Web Services
that are accessed via SOAP exchanges, though the SDKs are beginning to abstract
the programmer away from the complexity of the underlying data exchanges. You
may therefore find the documentation and source code examples that come with
the SDKs to be the most informative resources. In addition, you should install
a toolkit for creating word clouds that is compatible with your chosen SDK.
Many such toolkits are available in many programming languages, however, you
may want to check the availability of such a toolkit as part of the decision
making process for which SDK to install. Alternatively, you can feed your
results into a Web service that generates a word cloud independent of the SDK
you chose.

### Group Work
Your group may contain members with different disciplinary
backgrounds and skill sets. You need to work together on the homework and
everyone must contribute to the overall effort. For example, the non-technical
members of the group may contribute more to shaping the data collection for the
assignment, creating the task screens for the workers in HTML, and documenting
the work and outcomes. Those in the group with stronger technical skills will
probably need to lead the core programming effort. Though some division of
responsibility is healthy and expected, all group members should feel welcome
to contribute to all aspects of the assignment. For this assignment and for the
later group projects, you can rotate the use of the requester accounts or each
person should contribute a small amount to one requester account to fund
payments for the work performed. You may also choose to perform HITs as a way
to earn funds that can offset the cost of the work requested.

### Assignment
For the assignment, you must collect first impressions for one
visual design and aggregate the responses into a visually appealing word cloud.
The visual design could be the home page of a web site, graphic design,
photograph, or similar visual design. You can use your own work or something
that is available with a creative commons or similar "public domain" license.
The general workflow is to create a series of HITs asking workers to view the
design and enter a few (e.g. up to three) words that come to mind when first
viewing the design. Once the words are collected, you may need to implement a
second series of HITs to filter offensive or otherwise nonsense responses. The
filtered set of words can then be aggregated into a word cloud. The final
output should show the visual design and the word cloud next to it. All of the
processing (creating the HITs, extracting the outcomes, building the word
cloud, etc.) should be performed within a single program. At a minimum, your
program should accept as input the location of the visual design and the number
of workers to collect data from. The number of workers used and any
qualifications applied to filter the workers for producing the final output is
up to your group, but should be sufficient to produce a meaningful outcome. A
final recommendation is to experiment with the HITs and your code using the
Mechanical Turk sandbox prior to using the production site. Switching between
the sandbox and the production site can be accomplished in the configuration
file that comes with the selected SDK. This will help reduce the overall labor
costs and allow your group to iterate on the design of the worker task screens
to maximize their effectiveness.

### Report
You should submit (1) the source code of your project as a single ZIP
file, (2) a high quality image of the visual design and the corresponding word
cloud produced, and (3) responses to the following questions:

1. What programming environment did you use? What did you use for generating
   the word cloud?
2. Where did the visual design come from and why did you choose it?
3. How many workers were involved in producing the final word cloud?
4. What was the total labor cost for producing the word cloud? Don't include
   the costs related to any earlier experimentation.
5. How long did it take to produce the word cloud (i.e. from the time the
   program was started to when the word cloud was returned)?
6. Diagram the overall workflow or process that you implemented to produce the
   word cloud.
7. How would you characterize the quality of the first impressions captured by
   the word cloud?
8. How did the first impressions returned by the crowd match or deviate from
   your group's expectations for the design?
9. Describe some ways that might improve the efficiency or outcomes of the
   task?  For example, how could you achieve a higher quality outcome; or how
   could you reduce the number of workers required, the total labor costs, or
   the time required to produce an outcome of the same quality?  
10. From the perspective of the designer who created the design used in the
    project, how might being able to collect first impressions from potential
    users benefit the design process?

# Implementation Notes
## Additional Tasks
TODO This
