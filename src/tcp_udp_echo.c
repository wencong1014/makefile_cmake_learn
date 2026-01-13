#include <winsock2.h>
#include <ws2tcpip.h> // 为了 inet_pton, getaddrinfo 等新函数
#include <windows.h>
#pragma comment(lib, "ws2_32.lib") // 告诉编译器链接Winsock库

#include <unistd.h>
#include <stdio.h>
int main()
{
    // 初始化Winsock库
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
    {
        printf("WSAStartup failed.\n");
        return 1;
    }

    char *target_ip = "127.0.0.1";
    int start_port = 1, end_port = 100;
    struct sockaddr_in sa;
    int sock;
    for (int port = start_port; port <= end_port; port++)
    {
        sock = socket(AF_INET, SOCK_STREAM, 0);
        if (sock < 0)
        {
            perror("socket");
            continue;
        }
        sa.sin_family = AF_INET;
        sa.sin_port = htons(port);
        inet_pton(AF_INET, target_ip, &sa.sin_addr);
        // 设置连接超时（需用fcntl或setsockopt设置非阻塞后实现）
        if (connect(sock, (struct sockaddr *)&sa, sizeof(sa)) == 0)
        {
            printf("Port %d: OPEN\n", port);
            close(sock);
        }
        else
        {
            // 根据errno判断是关闭、过滤还是超时
        }
    }

    // 清理Winsock库
    WSACleanup();

    return 0;
}