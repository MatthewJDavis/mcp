using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(simple_web_app.Startup))]
namespace simple_web_app
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
