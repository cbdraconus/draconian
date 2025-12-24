using Microsoft.AspNetCore.Identity;
using Scheduler.Api.Models;

namespace Scheduler.Api.Data;

public static class SeedData
{
    public static async Task InitializeAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<SchedulerDbContext>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();

        if (!await roleManager.RoleExistsAsync("Admin"))
        {
            await roleManager.CreateAsync(new IdentityRole("Admin"));
        }

        if (!await roleManager.RoleExistsAsync("Supervisor"))
        {
            await roleManager.CreateAsync(new IdentityRole("Supervisor"));
        }

        if (!await roleManager.RoleExistsAsync("Officer"))
        {
            await roleManager.CreateAsync(new IdentityRole("Officer"));
        }

        if (!context.Ranks.Any())
        {
            context.Ranks.AddRange(
                new Rank { Id = Guid.NewGuid(), Name = "Officer", Code = "OFF" },
                new Rank { Id = Guid.NewGuid(), Name = "Sergeant", Code = "SGT" });
        }

        if (!context.Assignments.Any())
        {
            context.Assignments.AddRange(
                new Assignment { Id = Guid.NewGuid(), Name = "Field Force", Code = "FF" },
                new Assignment { Id = Guid.NewGuid(), Name = "Crime Scene", Code = "CS" },
                new Assignment { Id = Guid.NewGuid(), Name = "Crime Scene Evidence Unit", Code = "CSEU" });
        }

        if (!context.ShiftTypes.Any())
        {
            context.ShiftTypes.AddRange(
                new ShiftType { Id = Guid.NewGuid(), Name = "8-hour", Hours = 8 },
                new ShiftType { Id = Guid.NewGuid(), Name = "10-hour", Hours = 10 },
                new ShiftType { Id = Guid.NewGuid(), Name = "12-hour", Hours = 12 });
        }

        await context.SaveChangesAsync();

        var adminEmail = "admin@department.local";
        if (await userManager.FindByEmailAsync(adminEmail) is null)
        {
            var admin = new ApplicationUser
            {
                UserName = adminEmail,
                Email = adminEmail,
                EmailConfirmed = true
            };

            var result = await userManager.CreateAsync(admin, "ChangeMe!123");
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(admin, "Admin");
            }
        }
    }
}
