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
	@if ! command -v mdi &> /dev/null; then \
		echo "mdi is not installed, installing..."; \
		go install github.com/poneding/mdi@latest; \
	else \
		echo "mdi is already installed"; \
	fi

.PHONY: mdi_gen
mdi_gen: check_mdi
	@git pull
	@echo "Generating README.md..."
	@mdi gen -f README.md -t "我的知识库" -r --override --nav -v
