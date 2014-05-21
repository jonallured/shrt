# midman

A personal URL shortener using [Middleman][m] to build an [htaccess file][h]
with 301 redirects, deployed to [DigitalOcean][d].

[m]: http://middlemanapp.com/
[h]: http://en.wikipedia.org/wiki/Htaccess
[d]: https://www.digitalocean.com/

## Why would you do this?

I wanted a personal URL shortener where I could control every aspect of the
shortened URLs and also it was fun, shutup.

## How does this work?

Well, you have a yml file with your redirects and during the Middleman build
phase, this file is used to create the [Redirect directives][r] in the htaccess
file.  That file gets `rsync`ed to the server and Apache takes it from there.

[r]: http://css-tricks.com/snippets/htaccess/301-redirects/

## No really, how does this work?

Ok, so you want to add a redirect - here's how:

Add your redirect to the `data/links.yml` file

```yaml
- short: me
  long: http://jonallured.com
```

Deploy the site:

```sh
$ rake deploy
```

That's it!! Now when you request `example.com/me` it will redirect to
`http://jonallured.com` using a 301 redirect from your Apache server.

## What do I do to set this up?

The first thing is that you need an Apache server - I've been very happy with
[DigitalOcean][d], so you might want to check them out.

Once you've got your server setup, you need to have a domain you want to use
with your shortened URLs. Point that sucker at your server and wait for the DNS
gnomes to do their thing.

From there, things get a little fuzzy - you need to setup your server to serve
static sites and that's outside the scope of this README. If you decided to go
with DigitalOcean, there's a [good write up][w] that helped me with some of the
Apache setup, so check that out.

[w]: https://www.digitalocean.com/community/articles/how-to-set-up-apache-virtual-hosts-on-ubuntu-12-04-lts

If you can serve a static site and you can SSH as root to the server, then you
just need to setup the deploy Rake task by adding a `.env` file to the project
with your deploy target, something like this:

```
DEPLOY_TARGET=root@123.456.1.1:/var/www/path/to/site
```

That will tell `rsync` where to drop the Middleman site.

## This is weird and bitly is free...

Totally use bit.ly! This is just something fun I threw together and wanted to
share.