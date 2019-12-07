
# Ruby File Handling


## Change the permissions of one file

```ruby
FileUtils.chmod 0755, '/usr/bin/ruby', :verbose => true
```


## Change the permissions of many files

```ruby
FileUtils.chmod 0644, %w(my.rb your.rb his.rb her.rb)
```

