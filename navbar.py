import dash_bootstrap_components as dbc

navbar = dbc.NavbarSimple(
    children=[
        dbc.NavItem(dbc.NavLink("Home", href="/")),
        dbc.NavItem(dbc.NavLink("Page 1", href="/page1")),
        dbc.NavItem(dbc.NavLink("Page 2", href="/page2")),
        # dbc.DropdownMenu(
        #     children=[
        #         dbc.DropdownMenuItem("More pages", header=True),
        #         dbc.DropdownMenuItem("Page 2", href="#"),
        #         dbc.DropdownMenuItem("Page 3", href="#"),
        #     ],
        #     nav=True,
        #     in_navbar=True,
        #     label="More",
        # ),
    ],
    brand="4aGoof",
    brand_href="/",
    color="primary",
    dark=True,
    links_left=True,
    className='g-0 ms-auto flex-nowrap mt-3 mt-md-0',
)