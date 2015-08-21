using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(GISJavaScript.Startup))]
namespace GISJavaScript
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
