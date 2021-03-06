context("test-generate_text.R")


test_that("generate_text returns text string",
          {
            simresult=DSAIDE::simulate_idcharacteristics()
            result = vector("list", 1)
            result[[1]]$dat = simresult$ts
            #no maketext provided, should be character of length 1
            expect_is( DSAIDE::generate_text(result), "html" )
            expect_is( DSAIDE::generate_text(result), "character" )
            expect_length( DSAIDE::generate_text(result), 1)
            #maketext false is same as above            
            result[[1]]$maketext = FALSE
            expect_is( DSAIDE::generate_text(result), "html" )
            expect_is( DSAIDE::generate_text(result), "character" )
            expect_length( DSAIDE::generate_text(result), 1)
            #should now produce text
            result[[1]]$maketext = TRUE
            #should both be of class html and character
            expect_is( DSAIDE::generate_text(result), "html" )
            expect_is( DSAIDE::generate_text(result), "character" )
            result[[1]]$maketext = FALSE
            result[[1]]$showtext = 'Hello'
            expect_is( DSAIDE::generate_text(result), "html" )
            expect_is( DSAIDE::generate_text(result), "character" )
          })