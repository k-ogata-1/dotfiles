function path_shortn -a path
  if [ -z "$path" ]
    echo 'Usage: path_shortn <path>'
    return 1
  end
  echo "$path" | sed -r 's/([^/]{,1})[^/]*\//\1\//g'
end
