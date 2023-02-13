from dash import Dash, dcc, html, Input, Output, callback

from layouts import layout1, layout2, index
import callbacks
import dash_bootstrap_components as dbc
from navbar import navbar

app = Dash(__name__, suppress_callback_exceptions=True,external_stylesheets=[dbc.themes.SPACELAB])
server = app.server
home = html.H1('Welcome')
app.layout = html.Div([
    dcc.Location(id='url', refresh=False),
    navbar,
    html.Div(id='page-content')
])


@callback(Output('page-content', 'children'),
          Input('url', 'pathname'))
def display_page(pathname):
    menu_dict = {'/':index,'/page1':layout1,'/page2':layout2}
    if pathname in menu_dict.keys():
        print(pathname)
        return menu_dict[pathname]
    else:
        return '404'


if __name__ == '__main__':
    app.run_server(debug=True)
