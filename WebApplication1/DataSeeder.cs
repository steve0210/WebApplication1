using System.Collections.Generic;
using System.Linq;
using WebApplication1.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace WebApplication1
{
	public static class DataSeeder
	{
		public static IHost SeedData(this IHost host)
		{
			using (var scope = host.Services.CreateScope())
			{
				var context = scope.ServiceProvider.GetService<BloggingContext>();
				SeedPosts(context);
			}
			return host;
		}
		public static void SeedPosts(BloggingContext context)
		{
			if (!context.Blogs.Any())
			{
				var posts = new List<Post>
				{
					new Post { Title = "Afghanistan" },
					new Post { Title = "Albania" },
					new Post { Title = "Algeria" },
					new Post { Title = "Andorra" },
					new Post { Title = "Angola" },
					new Post { Title = "Antigua and Barbuda" },
					new Post { Title = "Argentina" },
					new Post { Title = "Armenia" },
					new Post { Title = "Aruba" },
					new Post { Title = "Australia" },
					new Post { Title = "Austria" },
					new Post { Title = "Azerbaijan" },
				};
				var blog = new Blog
				{
					Name = "abcddddd",
					Posts = posts
				};

				context.Add(blog);
				context.SaveChanges();
			}
		}
	}
}
