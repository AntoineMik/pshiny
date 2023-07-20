# Overview
This application utilizes a [jhsingle-native-proxy] (https://pypi.org/project/jhsingle-native-proxy/) to run a [Shiny for Python](https://shiny.posit.co/py/) application. In the full application, Jupyterhub acts as the hub for creating and destroying these jhsingle-native-proxy servers in place of Jupyter notebook servers.

# Shiny for Python
Shiny is a framework for web applications that allows users to build interactive data visualizations and dashboards.

Its key features include fast and simple development of web applications, smooth integration with popular Python libraries for data visualization and analysis. Responsive and dynamic user interfaces and real-time updates for interactive user experiences.

Shiny is Powerful, Customizable, Compatible with Python datascience Packages, and Production ready.

# jhsingle-native-proxy
jhsingle-native-proxy wraps an arbitrary webapp so it can be used in place of jupyter-singleuser in a JupyterHub setting.

Within JupyterHub this allows similar operation to jupyter-server-proxy except it also removes the Jupyter notebook itself, so it works directly with the arbitrary web service. This abstraction allows the proxy to serve dashboards and other visualization frameworks as independent, shareable servers.

OAuth authentication is enforced based on JUPYTERHUB_* environment variables.

# Local Deployment
1. Navigate up to the dashboard-images directory and build the docker file
    - docker build -f ./pshiny/Dockerfile -t polusai/hub-pshiny:latest .
2. Run it
    - docker run -p 8501:8501 polusai/hub-pshiny:latest
3. See it locally
    - Navigate to [localhost:8501](localhost:8501) in your browser

# Examples
## Plot output based on slider value
```
import matplotlib.pyplot as plt
import numpy as np
from shiny import App, render, ui

# Note that if the window is narrow, then the sidebar will be shown above the
# main content, instead of being on the left.

app_ui = ui.page_fluid(
    ui.layout_sidebar(
        ui.panel_sidebar(ui.input_slider("n", "N", 0, 100, 20)),
        ui.panel_main(ui.output_plot("plot")),
    ),
)


def server(input, output, session):
    @output
    @render.plot(alt="A histogram")
    def plot() -> object:
        np.random.seed(19680801)
        x = 100 + 15 * np.random.randn(437)

        fig, ax = plt.subplots()
        ax.hist(x, input.n(), density=True)
        return fig


app = App(app_ui, server)

```
[more examples](https://shinylive.io/py/examples/)

# Important Consideration

## Containerizing Shiny for Python
Shiny for Python uses [Uvicorn](https://www.uvicorn.org/) to containerize its apps. It is a common way of containerizing apps using [FastAPI deployments](https://fastapi.tiangolo.com/deployment/docker/).

To run the Shiny for python app in the docker container, it is necessary to use Uvicorn run commands instead of the typical Shiny run commands to expose the app outside the container.