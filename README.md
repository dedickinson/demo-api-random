# Demo API - Random

A super basic [Flask-based API](https://palletsprojects.com/p/flask/)
that just produces out a random number.

Run up minikube and then get started with:

    make

And blow it all away with:

    make cleanall

## Dev notes for Windows

To install `make` on Windows:

    choco install make

## Releases

I've setup a very basic release process under `make release`. Before you run this you must be logged
into the GitHub Docker repo:

    docker login docker.pkg.github.com --username <username>

You'll need a [PAT](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) in order to login. It'll need `write:packages` scope.

## References

* [Connection refused? Docker networking and how it impacts your image](https://pythonspeed.com/articles/docker-connection-refused/)
is a great article about docker networking.
  * If you're using minikube make sure you run `minikube ip`
