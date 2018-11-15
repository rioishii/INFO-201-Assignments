# Who Are Representing You?

You task is to display some information about elected officials,
representing a given US address.  Given the address, your information
sheet should include the federal, state, and county level
representatives, and summary information about the state's members of
the House of Representatives.

The task may sound overwhelming, but API-s help you.  In particular,
we expect you to use
[google civic platform](https://developers.google.com/civic-information/)
that links elected officials for a given address, and
[pro publica congress](https://www.propublica.org/datastore/api/propublica-congress-api)
that includes information about state representatives, such as party
membership and voting history.

## Proceed along the following lines:

### 1. Become familiar with the example _index.html_ that is
included.

### 2. Learn about the basics of
[google civic platform API](https://developers.google.com/civic-information/)
and 
[pro publica congress API](https://www.propublica.org/datastore/api/propublica-congress-api). Both
of these API-s require a valid key.  ProPublica Congress API key
can be requested on the same webpage, for Google Civic Platform
API, follow the instructions
[here](https://support.google.com/cloud/answer/6158862).

### 3. Store the API keys

Store the keys on your computer:
* don't upload these on GitHub!
* don't put these in the code that will be uploaded in GitHub!

There are many ways to achieve this.  However, from grading point of
view, please do like this:
1. create an R file _keys.R_ in the same project folder.  The file
   should contain the keys in the form:  

```
google.key <- "123xyz"
propublica.key <- "123xyz"
```
   The file should not contain anything else.  Please use exactly the
   same names for the keys.
1. add this file to _.gitignore_




### 4. I recommend first to experiment with the queries on the interactive
consoles, provided with both API-s.  In particular, you should manage
to: 
* get the elected officials' info from Google's _civic platform_
* get the list of state representatives from _ProPublica Congress_
* get selected representative's voting history and personal
  information from _ProPublica Congress_
  

### 5. Short Introduction

Write a short introduction (a few sentences) where you explain where
you get the following information.  Provide API links!  Use
bold/italics according to need.
  

### 6. Create a table of all elected officials 

The table should contain all elected officials from Civic Platform for
the address. The table should include
* name
* position
* party
* email (link)
* phone
* photo
Ensure that missing information (such as missing phone numbers) are
displayed in an pleasant and informative way (such as _not available_
or '-') and not as `<NA>` or other kind of ugly code.

### 7. For the House representatives, display:
* state name and the number of representatives for that state
* create a _horizontal barplot_ (histogram) that shows the
  distribution of party affiliations for the
  representatives of the state
* create another relevant visualization

Ensure the figures are appropriately labeled, and font sizes and colors
are appropriate.


### 8. Tell Us about a Representative

Finally, pick an arbitrary representative for that state and display some personal information
about him/her:
* name.  The name should be included in the header.
* age, in years, computed based on the birthday and current date
* twitter name (should be link to the corresponding twitter page)
* percentage of votes he/she cast with the majority through the last
  20 or so votings.



### 8. Ensure that you explain and introduce your charts and tables with
suitable amount of text.


## Further ideas

If you consider these ideas relevant, you may dig deeper into the data
and create a group project that shows how many times representatives
have voted for/against certain type of legislation, and how often they
have voted along/across party lines.

