# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.6
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---

from shiny import App, reactive, render, ui

# # Basic Shiny App

# Shiny applications consist of two parts: 
# 1 - the user interface (or UI), and 
# 2 - the server function. 
# These are combined using a shiny.App object

# +
# 1 - User Interface; defines what displays
app_ui = ui.page_fluid(
    "Slide to a number and see it multiply by 5 live",
    ui.input_slider("n", "Number", 4, 600, 40),
    ui.output_text_verbatim("txt"),
)

# 2 - The server function
def server(input, output, session):
    @output
    @render.text
    def txt():
        return f"The number times five is {input.n() * 5}"

# Shiny App object
app = App(app_ui, server)
# -

# input_slider() creates a slider.
# output_text_verbatim() creates a field to display dynamically generated text.

# Note that inside of the server function, we do the following:
#
# define a function named txt, whose output shows up in the UI’s output_text_verbatim("txt").
# decorate it with @render.text, to say the result is text (and not, e.g., an image).
# decorate it with @output, to say the result should be displayed on the web page.

# Our txt() function takes the value of our slider n, and returns its valued multiplied by 5. To access the value of the slider, we use input.n(). This is a callable object (like a function) that must be invoked to get the value.

# This reactive flow of data from UI inputs, to server code, and back out to UI outputs is fundamental to how Shiny works
