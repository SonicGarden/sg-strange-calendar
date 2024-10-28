.PHONY: test/calendar
test/calendar:
	ruby test/sg_strange_calendar_test.rb --no-plugins

.PHONY: test/table
test/table:
	ruby test/sg_strange_calendar/table_test.rb --no-plugins