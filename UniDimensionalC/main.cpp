#include <iostream>
#include <stdio.h>

using namespace std;
//initializare cu 0

// index de la 0 pt get


int a[8000];
int n=8000;
int q,task,ct_add;
int i;

int to_byte(int x)  // //
{
    return (x+7)/8;
}

void Umplere(int st,int dr,int val)  // //
{
    i=st;
    while( i<=dr )
    {
        a[i]=val;
        i++;
    }
}

void Add()
{
    int desc;
    int desc_size;
    int st,dr;
    int found;

    scanf("%d",&desc);
    scanf("%d",&desc_size);

    desc_size = to_byte( desc_size );
    st=0;
    dr=0;
    found=0;

    int lg=0;
    i=0;
    while(i<n)
    {
        if( a[i]==0 )
        {
            lg++;
        }
        if( a[i]!=0 )
            lg=0;
        if( lg==desc_size )
        {
            dr=i;
            st=i-desc_size+1;
            found=1;
            Umplere(st,dr,desc);
            break;
        }
        i++;
    }
    printf("%d: (%d, %d)\n",desc,st,dr);
}

void Get()
{
    int desc;
    int st,dr;
    int found;

    scanf("%d",&desc);

    st=0;
    dr=0;
    found=0;

    i=0;
    while(i<n)
    {
        if( a[i]==desc )
        {
            if( !found )
            {
                st=i;
                found=1;
            }
            dr=i;
        }
        i++;
    }
    printf("(%d, %d)\n",st,dr);
}

void Afisare()  // //
{
    int i=0;
    int desc;
    int st,dr;

    while(i<n)
    {
        if( a[i]!=0 )
        {
            desc=a[i];
            st=i;
            while( a[i]==desc )
                i++;
            i--;
            dr=i;
            printf("%d: (%d, %d)\n",desc,st,dr);
        }
        i++;
    }
}
void Delete() /// / / /
{
    int desc;

    scanf("%d",&desc);

    i=0;
    while(i<n)
    {
        if( a[i]==desc )
            a[i]=0;
        i++;
    }
    Afisare();
}

void Defragmentation()
{
    int pzero,pval;
    pzero=0;
    pval=0;
    while(pval<n)
    {
        if( a[pval]!=0 )
        {
            a[pzero]=a[pval];
            if( pval!=pzero )
                a[pval]=0;
            pzero++;
        }
        pval++;
    }
    Afisare();
}

int main()  // //
{
    Umplere(0,n-1,0);
    scanf("%d", &q);
    while( q )
    {
        scanf("%d", &task);

        if( task==1 ) /// ADD
        {
            scanf("%d", &ct_add);
            while( ct_add )
            {
                Add();
                ct_add--;
            }
        }
        if( task==2 ) /// GET
        {
            Get();
        }
        if( task==3 ) /// Del
        {
            Delete();
        }
        if( task==4 ) /// Defrag
        {
            Defragmentation();
        }
        q--;
    }
    return 0;
}
/// https://cs.unibuc.ro/~crusu/asc/Arhitectura%20Sistemelor%20de%20Calcul%20(ASC)%20-%20Tema%20Laborator%202024.pdf
/*
4
1
5
1
124
4
350
121
75
254
1024
70
30

2
121

3
4

4

*/
