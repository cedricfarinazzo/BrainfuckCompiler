# BrainfuckCompiler

### Build Status

| Branch | Status |
|--------|--------|
|        |        |
| Master | [![Build Status](https://travis-ci.com/cedricfarinazzo/BrainfuckCompiler.svg?token=PWWWrwHwq3fxP6xWcPoJ&branch=master)](https://travis-ci.com/cedricfarinazzo/BrainfuckCompiler)     |


## How To Build

```

git clone https://github.com/cedricfarinazzo/BrainfuckCompiler.git
cd BrainfuckCompiler
make

```

You can found executable files in bin folder.

## Bff BrainfuckCompiler

Bff is a brainfuck compiler made in Caml.

## Usage

### Help

```
$ bff -help
```

### Verbose mode

```
$ bff -v ...
```

### Running mode

```
$ bff -i brainfuck.b
Hello World!
```

### Building mode 

```
$ ./bff -i brainfuck.b -o brainfuck.exe
$ ./brainfuck.exe
Hello World!
```

## Contribute

- Fork this project
- Create a new branch
- Make your changes
- Merge your branch to master
- Create a pull request and explain your changes

## License

See the [LICENSE](LICENSE) file for licensing information.
