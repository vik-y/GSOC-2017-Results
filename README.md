# GSOC 2017 Result

This repository is an attempt to understand the number of selections in GSOC 2017.

I wrote this using ruby because activerecord made by job really easy.


`combined.json`
It is a complete json file of all the results.

`data` folder houses the data that I extracted from gsoc official website.

### How this works?
`generate.rb` file generates an sqlite database `gsoc.db` in which it adds all the organisations,
students, projects and tags in an organized way. Now you can write sql queries in that
to get more interesting results.

For basic use cases you can just download the `gsoc.db` file and start your analysis. In case if you are looking for some advanced analysis you can find `combined.json` and `data` folder handy. Also don't forget to raise a pull request for what you do.

#### Basic Usage
In case if you want to generate the `gsoc.db` file on your own system   
```rb
# Assuming you have ruby installed on your system
gem install activerecord
git clone https://github.com/vik-y/GSOC-2017-Results
cd GSOC-2017-Results
ruby generate.rb
```

### Contribution
Please note that this code was written in a lot of hurry and requires a lot of fixups.
If you have any idea in mind then feel free to raise an issue or a pull request.
