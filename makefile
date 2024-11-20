build:
	 emacs -Q --batch -l publish.el

clean:
	rm -rf ./output

serve:
	npx serve -p 8081 --cors ./output
