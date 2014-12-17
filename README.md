# Uploadbox

Easy uploads for Rails application

[![Code Climate](https://codeclimate.com/github/startae/uploadbox.png)](https://codeclimate.com/github/startae/uploadbox)

## Early Beta

This is still an early beta version and will change a lot until it reaches API stability.
That said, it's already being used on production projects.


## Installation

Make sure you have [ImageMagick](http://www.imagemagick.org/) installed.

Add to Gemfile

```
gem 'uploadbox', '0.2.0'
```

Run generators

```
rails g uploadbox:image
```

Migrate database

```
rake db:migrate
```

Add jquery and uploadbox to `application.js`

```
//= require jquery
//= require jquery_ujs
//= require uploadbox
```

Add uploadbox to `application.css`

```
/*
 *= require uploadbox
 */
```

Create a development bucket on [Amazon S3](http://aws.amazon.com/s3/)

Edit CORS config for the bucket

```
<CORSConfiguration>
  <CORSRule>
    <AllowedOrigin>http://localhost:3000</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
  </CORSRule>
</CORSConfiguration>
```

Get S3 Key and Secret from Amazon S3 Credentials and update your `secrets.yml` file.

```
development:
  s3_bucket: your-bucket-name
  s3_key: your-s3-key
  s3_secret: your-s3-secret
```

## Usage

Add `uploads_one` to your model

```
class Post < ActiveRecord::Base
  uploads_one :picture, thumb: [100, 100], regular: [600, 300], placeholder: 'default.png'
end
```

If `placeholder` is set posts without uploads will render the placeholder.
Empty `@post.picture.thumb` will render `app/assets/images/thumb_default.png`

Add field to form

```
<%= f.uploads_one :picture %>
```

Allow attribute on controller

```
def post_params
  params.require(:post).permit(:title, :body, :picture)
end
```

Show image

```
<%= img @post.picture.regular if @post.picture? %>
```

## Recreate versions

You might come to a situation where you want to retroactively change a version or add a new one. You can use the `update_#{upload_name}_versions!` method to recreate the versions from the base file.
For a post with a picture:

```
Post.update_picture_versions!
```


## Heroku

Create a production bucket on S3 (Don't use your development bucket)

```
<CORSConfiguration>
  <CORSRule>
    <AllowedOrigin>http://yourdomain.com</AllowedOrigin>
    <AllowedMethod>GET</AllowedMethod>
    <AllowedMethod>POST</AllowedMethod>
    <AllowedMethod>PUT</AllowedMethod>
    <AllowedHeader>*</AllowedHeader>
  </CORSRule>
</CORSConfiguration>
```

Set environment variables

```
heroku config:add \
HEROKU_API_KEY=ab12acvc12 \
HEROKU_APP=your-app-name \
S3_KEY=AAAA123BBBB \
S3_SECRET=abc123ABcEffgee122 \
S3_BUCKET=uploads-production
```

Update your secrets.yml file

```
production:
  s3_key:  <%= ENV["S3_KEY"] %>
  s3_secret: <%= ENV["S3_SECRET"] %>
  s3_bucket: <%= ENV["S3_BUCKET"] %>
```

Add Redis

```
heroku addons:add rediscloud
```

## Upgrade from 0.1.x

If are upgrading from 0.1.x you will need to create a migration to add a column named `original_file` to the `images` table

```
rails g migration add_original_file_to_images original_file:string
rake db:migrate
```
