# Gitea on Kubernetes

需提供以下配置项

- GITEA_WORK_DIR  工作目录的绝对路径，默认为/data，需挂载volume到此路径
- USER            Gitea 运行时使用的系统用户，它将作为一些 repository 的访问地址的一部分，默认使用 git
- CONFIG          Gitea 主配置文件，将复制为 $GITEA_WORK_DIR/custom/conf/app.ini



通过 ingress nginx 代理 ssh

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: tcp-services
  namespace: intra
data:
  222: "intra/git:2222"
```

大于 2000 的端口可能会被占用，导致监听失败，所以使用 三位数 端口来转发到 git 2222 端口（使用git账号运行gitea，无权限监听三位数端口）
