
.PHONY: demo
demo:
	@dart example/cuid_example.dart

.PHONY: test
test:
	@pub run test test/

.PHONY: watch
watch:
	@reflex -g '**/*.dart' -- sh -c 'clear && make test'
