/* Author: Thomas Mortier
 */
#include <chrono>
#include <string>
#include <fstream>
#include <vector>
#include <iostream>

int main(int argc, char** argv)
{
    std::string file {static_cast<std::string>(argv[1])};
    std::ifstream in {file};
    std::string line;
    std::vector<unsigned long> nums;
    auto t1 = std::chrono::high_resolution_clock::now();
    try 
    {
        while (std::getline(in, line))
        {
            unsigned long num {std::stoul(line)};
            nums.push_back(num);
        }
    }
    catch (std::ifstream::failure e)
    {
        std::cerr << "Ooops, something went wrong: " << e.what() << '\n';
        exit(1);
    }
    unsigned long s1 {0}, s2 {0};
    for (auto const& x: nums)
    {
        for (auto const& y: nums)
        {
            for (auto const& z: nums)
            {
                if (x+y==2020)
                    s1 = x*y;
                if (x+y+z==2020)
                    s2 = x*y*z;
                if (s1 != 0 && s2 != 0)
                    goto endLoop;
            }
        }
    }
    endLoop:
    std::cout << s1 << '\n';
    std::cout << s2 << '\n';
    auto t2 = std::chrono::high_resolution_clock::now();
    auto time = std::chrono::duration_cast <std::chrono::milliseconds>(t2-t1).count();
    std::cout << "Executed in " << time << " ms\n"; 
    return 0;
}
