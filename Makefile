.PHONY:
commit: mdi_gen
	@echo "Committing changes..."
	# check if there are any changes, if not, do nothing, otherwise, commit and push
	@if [ -z "$$(git status --porcelain)" ]; then \
		echo "No changes to commit."; \
	else \
		git add .; \
		git commit -m "Update archives."; \
		git push; \
	fi

.PHONY: check_mdi
check_mdi:
	@echo "Checking if mdi is installed..."
	@which mdi > /dev/null && \
	 echo "mdi is already installed" || \
	  (echo "mdi is not installed, installing now..."; \
	  go install github.com/poneding/mdi@latest && \
	  echo "mdi installed successfully" || \
	  echo "mdi installation failed, please try again later.")

.PHONY: mdi_gen
mdi_gen: check_mdi
	@git pull
	@echo "Generating README.md..."
	@mdi gen -f README.md -t "我的知识库" -r --override --nav -v
