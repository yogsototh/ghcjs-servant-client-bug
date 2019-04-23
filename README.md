> This project has two homes.
> It is ok to work in github, still, for a better decentralized web
> please consider contributing (issues, PR, etc...) throught:
>
> https://gitlab.esy.fun/yogsototh/ghcjs-servant-client-bug

---


# INSTALL

~~~
cd .../projects/
git clone https://github.com/haskell-servant/servant.git
~~~

If you want to be certain to use a working version you could.

~~~
git checkout 5e215cef6834575c59354d5b1f1cce4d47f9aaa0
~~~

Then clone this project in the same directory:

~~~
cd .../projects/
~~~
## Develop

To launch the server:

`./launch.sh`.

You might need to install `live-reload` (`npm install live-reload`)
for basic live recompilation and reload.
If this is the first time, it might take a _long_ time.

Once finished you can verify everything worked fine here:

- <http://localhost:8080/index-dev.html>.

Organization:

- `src/` contains `servant` code.
- `ui/` directory contains the frontend code.
- `ui/assets/` contains the HTML, CSS and JS.
- `ui/app/` contains the Haskell code that will be compiled to JS via GHCJS
- `ui/src/` contains the Haskell code that will be compiled to JS via GHCJS
