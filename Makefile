.PHONY: test/calendar
test/calendar:
	ruby test/sg_strange_calendar_test.rb --no-plugins

.PHONY: test/table
test/table:
	ruby test/sg_strange_calendar/table_test.rb --no-plugins

.PHONY: test/horizonal
test/horizonal:
	ruby test/sg_strange_calendar/presenter/horizonal_presenter_test.rb --no-plugins

.PHONY: test/vertical
test/vertical:
	ruby test/sg_strange_calendar/presenter/vertical_presenter_test.rb --no-plugins
