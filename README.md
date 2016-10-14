# shrt

A personal URL shortener that builds an [htaccess file][h] with 301 redirects,
deployed to [DigitalOcean][d].

## Why would you do this?

I wanted a personal URL shortener where I could control every aspect of the
shortened URLs and also it was fun, shutup.

## How does this work?

Its easy - there's a yml file with your redirects and a `build` rake task writes
[Redirect directives][r] for each one in a htaccess file. That file gets
`rsync`ed to the server and Apache takes it from there.

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

If you can serve a static site and you can SSH into the server, then you just
need to setup the deploy Rake task by copying the example dot-env file and
setting the details:

```
$ cp .env.example .env
```

Replace the ssh and path with your details:

```
DEPLOY_TARGET=root@123.456.1.1:/var/www/path/to/site
```

That will tell `rsync` where to drop the site.

The last thing is that you have to configure Apache to allow you to use an
.htaccess file. That's done here:

```
$ sudo vim /etc/apache2/apache2.conf
```

And here's the section you want to change:

```
<Directory /var/www/>
  Options Indexes FollowSymLinks
  AllowOverride All
  Require all granted
</Directory>
```

It's the `AllowOverride All` part that does the trick.

## But wait, where are the stats??

Here's the great thing about this aproach - Apache is really good at writing log
files, so if you want to know how many time a particular redirect has been used,
you simply parse those logs. Take a look at the `report.rb` script and you'll
see what I use.

## This is weird and bitly is free...

Totally use [bit.ly][b]! This is just something fun I threw together and wanted to
share.

[b]: https://bitly.com/
[d]: https://www.digitalocean.com/
[h]: http://en.wikipedia.org/wiki/Htaccess
[r]: http://css-tricks.com/snippets/htaccess/301-redirects/
[w]: https://www.digitalocean.com/community/articles/how-to-set-up-apache-virtual-hosts-on-ubuntu-12-04-lts
