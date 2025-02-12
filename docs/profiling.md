Much troubles with all different profiles. The one that -in the end- did the job was cProfile.


```
python -m cProfile -o <trace_file.prof> -m mytool <args>
```

to visualize the `.prof` file:


`pipx install snakeviz`

to run:

`snakevis trace_file.prof`
